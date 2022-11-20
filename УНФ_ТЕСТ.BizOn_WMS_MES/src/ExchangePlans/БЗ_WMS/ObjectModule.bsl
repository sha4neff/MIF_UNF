Функция ИмяПеречисления(Ссылка)
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда Возврат ""; КонецЕсли;
	ИмяПеречисления = Ссылка.Метаданные().Имя;
	Индекс = Перечисления[ИмяПеречисления].Индекс(Ссылка);
	Возврат Метаданные.Перечисления[ИмяПеречисления].ЗначенияПеречисления[Индекс].Имя;
КонецФункции

Функция ОбъектОтправлен(Ссылка) Экспорт
	Запрос=Новый Запрос(
	"ВЫБРАТЬ
	|	БЗ_ОтправленныеОбъекты.Узел,
	|	БЗ_ОтправленныеОбъекты.Объект
	|ИЗ
	|	РегистрСведений.БЗ_ОтправленныеОбъекты КАК БЗ_ОтправленныеОбъекты
	|ГДЕ
	|	БЗ_ОтправленныеОбъекты.Узел = &Узел
	|	И БЗ_ОтправленныеОбъекты.Объект = &Ссылка");
	Запрос.УстановитьПараметр("Узел",ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Возврат НЕ Запрос.Выполнить().Пустой();
КонецФункции

Функция СсылкаНаОбъект(Ссылка) Экспорт	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		//Если ТипЗнч(Ссылка)=Тип("СправочникСсылка.БЗ_ВидыПартииПроизводства") Тогда
		//	Возврат Строка(Ссылка.Код);
		//ИначеЕсли ТипЗнч(Ссылка)=Тип("СправочникСсылка.БЗ_ТипыДвижений_ТСД") Тогда
		//	Возврат Строка(Ссылка.Код);
		//КонецЕсли;		
		Возврат Строка(Ссылка.УникальныйИдентификатор());
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

Функция ДобавитьОбъектВОтправленые(Ссылка) Экспорт
	Если Не ОбъектОтправлен(Ссылка) Тогда
		Попытка
			МенеджерЗаписи=РегистрыСведений.БЗ_ОтправленныеОбъекты.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Узел=ЭтотОбъект.Ссылка;
			МенеджерЗаписи.Объект=Ссылка;
			МенеджерЗаписи.Записать(Истина);
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция Получить_ГруппаУниверсальная(Ссылка)
	ДобавитьОбъектВОтправленые(Ссылка);
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);	
	Родитель=Новый Структура();
	Данные.Вставить("Родитель",Родитель);
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=Данные.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		ДобавитьОбъектВОтправленые(ТКРодитель);
		СТРодитель.Вставить("GUID",СсылкаНаОбъект(ТКРодитель));
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);				
		ТКРодитель=ТКРодитель.Родитель;		
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;
	Возврат Данные;	
КонецФункции

Функция Получить_ГруппаУниверсальнаяПодчиненный(Ссылка)
	ДобавитьОбъектВОтправленые(Ссылка);
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);
	Данные.Вставить("Владелец",СсылкаНаОбъект(Ссылка.Владелец));
	Родитель=Новый Структура();
	Данные.Вставить("Родитель",Родитель);
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=Данные.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		ДобавитьОбъектВОтправленые(ТКРодитель);
		СТРодитель.Вставить("GUID",СсылкаНаОбъект(ТКРодитель));
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);
		СТРодитель.Вставить("Владелец",СсылкаНаОбъект(ТКРодитель.Владелец));
		ТКРодитель=ТКРодитель.Родитель;		
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;	
	Возврат Данные;	
КонецФункции

Функция УНФ_1_6_ПреобразоватьИзШестнадцатиричнойСистемыСчисленияВДесятичноеЧисло(Знач Значение)
	
	Значение = НРег(Значение);
	ДлинаСтроки = СтрДлина(Значение);
	
	Результат = 0;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		Результат = Результат * 16 + Найти("0123456789abcdef", Сред(Значение, НомерСимвола, 1)) - 1;
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧГ=0");
	
КонецФункции

Функция УНФ_1_6_ЧисловойКодПоСсылке(Ссылка)
	ШестнадчатиричноеЧисло = СтрЗаменить(Строка(Ссылка.УникальныйИдентификатор()),"-","");
	Возврат УНФ_1_6_ПреобразоватьИзШестнадцатиричнойСистемыСчисленияВДесятичноеЧисло(ШестнадчатиричноеЧисло);
КонецФункции

Функция ПолучитьJSON_Номенклатура(Ссылка) Экспорт
	Узел=ЭтотОбъект.Ссылка;
	Если Ссылка.ЭтоГруппа Тогда
		НоменклатураСтруктура=Новый Структура();
		НоменклатураСтруктура.Вставить("GUID",Ссылка.УникальныйИдентификатор());
		НоменклатураСтруктура.Вставить("Код",Ссылка.Код);
		НоменклатураСтруктура.Вставить("Наименование",Ссылка.Наименование);
		Родитель=Новый Структура();
		НоменклатураСтруктура.Вставить("Родитель",Родитель);
		ТКРодитель=Ссылка.Родитель;
		СТРодитель=НоменклатураСтруктура.Родитель;
		Пока ЗначениеЗаполнено(ТКРодитель) Цикл
			СТРодитель.Вставить("GUID",ТКРодитель.УникальныйИдентификатор());
			СТРодитель.Вставить("Код",ТКРодитель.Код);
			СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);		
			ТКРодитель=ТКРодитель.Родитель;
			Если ЗначениеЗаполнено(ТКРодитель) Тогда
				Родитель=Новый Структура();
				СТРодитель.Вставить("Родитель",Родитель);
				СТРодитель=СТРодитель.Родитель;
			КонецЕсли;
		КонецЦикла;
		JSONПакет=Новый Структура();
		JSONПакет.Вставить("Тип","НоменклатураГруппа");
		JSONПакет.Вставить("КодБД",Узел.КодБД);
		JSONПакет.Вставить("Объект",НоменклатураСтруктура);
		Возврат ПланыОбмена.БЗ_WMS.Записать_JSON(JSONПакет);
	КонецЕсли;
	Отбор=Новый Структура();
	НоменклатураСтруктура=Новый Структура();
	НоменклатураСтруктура.Вставить("GUID",Ссылка.УникальныйИдентификатор());
	НоменклатураСтруктура.Вставить("Код",Ссылка.Код);
	НоменклатураСтруктура.Вставить("Наименование",Ссылка.НаименованиеПолное);
	НоменклатураСтруктура.Вставить("Артикул",Ссылка.Артикул);
	НоменклатураСтруктура.Вставить("БазоваяЕдиница",Ссылка.УникальныйИдентификатор());
	НоменклатураСтруктура.Вставить("КИСРейтинг",0);        
	НоменклатураСтруктура.Вставить("КИСРазрешитьВводБезШК",ссылка.БЗ_РазрешитьВводБезШК);

	НоменклатураСтруктура.Вставить("ГруппаОтбора",0);	
	НоменклатураСтруктура.Вставить("Изготовитель",?(ЗначениеЗаполнено(Ссылка.Изготовитель),Строка(Ссылка.Изготовитель.УникальныйИдентификатор()),""));
 	Родитель=Новый Структура();
	НоменклатураСтруктура.Вставить("Родитель",Родитель);
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=НоменклатураСтруктура.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		СТРодитель.Вставить("GUID",ТКРодитель.УникальныйИдентификатор());
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);		
		ТКРодитель=ТКРодитель.Родитель;
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;
	
	// Заполняем базовую по товару
	МЕдиницы=Новый Массив();	
	Единица=Новый Структура();
	Единица.Вставить("GUID",Ссылка.УникальныйИдентификатор());
	Единица.Вставить("Код",Ссылка.Код+"_"+Ссылка.ЕдиницаИзмерения.Код);
	Единица.Вставить("Наименование",Ссылка.ЕдиницаИзмерения.Наименование);
	Единица.Вставить("Объем",Ссылка.Объем/1000);
	Единица.Вставить("Вес",Ссылка.Вес);
	Единица.Вставить("Ширина",Ссылка.Ширина);
	Единица.Вставить("Высота",Ссылка.Высота);		 
	Единица.Вставить("Глубина",Ссылка.Длина);
	Единица.Вставить("Коэффициент",1);
	МЕдиницы.Добавить(Единица);

	// Алтернативные единицы неиспользуются	
	//Пока Единицы.Следующий() Цикл
	//	 //Если Единицы.ПометкаУдаления Тогда
	//	 //   Продолжить;
	//	 //КонецЕсли;		
	//	 Единица=Новый Структура();
	//	 Единица.Вставить("GUID",Единицы.Ссылка.УникальныйИдентификатор());
	//	 Единица.Вставить("Код",Единицы.Код);
	//	 Единица.Вставить("Наименование",Единицы.Наименование);
	//	 Единица.Вставить("Объем",Единицы.Объем);
	//	 Единица.Вставить("Вес",Единицы.Вес);
	//	 Единица.Вставить("Ширина",Единицы.Ширина);
	//	 Единица.Вставить("Высота",Единицы.Высота);		 
	//	 Единица.Вставить("Глубина",Единицы.Глубина);
	//	 Единица.Вставить("Коэффициент",Единицы.Коэффициент);
	//	 МЕдиницы.Добавить(Единица);
	//КонецЦикла;
	
	МХарактеристики=Новый Массив(); 
	Характеристики=Справочники.ХарактеристикиНоменклатуры.Выбрать(,Ссылка); // Характеристики номенклатуры
	Пока Характеристики.Следующий() Цикл
		Характеристика=Новый Структура();
		Характеристика.Вставить("GUID",Характеристики.Ссылка.УникальныйИдентификатор());
		Характеристика.Вставить("Наименование",Характеристики.Наименование);
		Характеристика.Вставить("КИСРейтинг",0);
		Характеристика.Вставить("Свойства",Новый Массив());
		МХарактеристики.Добавить(Характеристика);
	КонецЦикла;	
	
	МШтрихкоды=Новый Массив();	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
	                    |	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
	                    |	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод
	                    |ИЗ
	                    |	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	                    |ГДЕ
	                    |	ШтрихкодыНоменклатуры.Номенклатура = &Владелец");
	Запрос.Параметры.Вставить("Владелец",Ссылка);	
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		Штрихкод=Новый Структура();
		Штрихкод.Вставить("Штрихкод",Выборка.Штрихкод);		
		Если ЗначениеЗаполнено(Выборка.Характеристика) Тогда
			Если ТипЗнч(Выборка.Характеристика.Владелец)=Тип("СправочникСсылка.Номенклатура") Тогда
				Штрихкод.Вставить("ХарактеристикаGUID",СокрЛП(Выборка.Характеристика.УникальныйИдентификатор()));
			Иначе
				Штрихкод.Вставить("ХарактеристикаGUID",СокрЛП(Выборка.Характеристика.УникальныйИдентификатор())+СокрЛП(Ссылка.УникальныйИдентификатор()));
			КонецЕсли;
		КонецЕсли;
		Штрихкод.Вставить("ЕдиницаGUID",СокрЛП(Выборка.Номенклатура.УникальныйИдентификатор()));
		МШтрихкоды.Добавить(Штрихкод);
	КонецЦикла;
		
	НоменклатураСтруктура.Вставить("Характеристики",МХарактеристики);
	НоменклатураСтруктура.Вставить("Единицы",МЕдиницы);
	НоменклатураСтруктура.Вставить("Штрихкоды",МШтрихкоды);
	JSONПакет=Новый Структура();
	JSONПакет.Вставить("Тип","Номенклатура");
	JSONПакет.Вставить("КодБД",Узел.КодБД);
	JSONПакет.Вставить("Объект",НоменклатураСтруктура);
	Возврат ПланыОбмена.БЗ_WMS.Записать_JSON(JSONПакет);
КонецФункции

Функция ПолучитьJSON_ЗаданиеНаПогрузку(Ссылка) Экспорт
	Узел=ЭтотОбъект.Ссылка;		
	НСклад=Узел.Склады.Найти(Ссылка.Склад,"Склад");
	Получатель=Ссылка.Получатель;
	Документ=Новый Структура();		
	Документ.Вставить("GUID",Ссылка.УникальныйИдентификатор());	
	Документ.Вставить("Barcode",УНФ_1_6_ЧисловойКодПоСсылке(Ссылка.ДокументОснование));	
	НомерДО=СокрЛП(Ссылка.ДокументОснование.Номер);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказПокупателя.Номер КАК Номер
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.БЗ_ГлавныйЗаказ = &БЗ_ГлавныйЗаказ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказПокупателя.Дата";
	Запрос.УстановитьПараметр("БЗ_ГлавныйЗаказ", Ссылка.ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерДО=НомерДО+"/"+СокрЛП(Выборка.Номер);
	КонецЦикла;
	Комментарий=Строка(Получатель.Ответственный) +" "+ Ссылка.ДокументОснование.Комментарий;
	ТранспортноеСредство="";
	Водитель="";	
	Документ.Вставить("Док",СокрЛП(НомерДО)+" ("+Формат(Ссылка.ДокументОснование.Дата,"ДФ=dd.MM.yyyy")+"); "+Получатель.Наименование);	
	//Документ.Вставить("Склад",НСклад.СкладWMS);
	Документ.Вставить("Склад",1);
	Документ.Вставить("КонтрагентGUID",Получатель.УникальныйИдентификатор());
	Документ.Вставить("КонтрагентКод",Получатель.Код);
	Документ.Вставить("КонтрагентНаименование",Получатель.Наименование);
	Документ.Вставить("КонтрагентНаименованиеПолное",Получатель.НаименованиеПолное);
	Документ.Вставить("ТранспортноеСредство",ТранспортноеСредство);
	Документ.Вставить("Прицеп","");
	Документ.Вставить("Водитель",Водитель);
	Документ.Вставить("ДатаОтгрузки",Ссылка.ДокументОснование.ДатаОтгрузки);
	Документ.Вставить("Проведен",Истина);
	Документ.Вставить("Комментарий",Комментарий+?(ЗначениеЗаполнено(Ссылка.Комментарий),"; "+Ссылка.Комментарий,""));	
	ДатаОтгрузки=Ссылка.Дата;
	ТБПакеты=БЗ_WMS_Обмен.ТБПакеты_ЗаданияНаПогрузку(Ссылка);
	МТовары=Новый Массив();		
	Если НЕ Ссылка.Проведен Тогда
		ТБПакеты.Очистить();
	КонецЕсли;
	Для Каждого СТТовар Из ТБПакеты Цикл
		Если СТТовар.Количество=0 Тогда	Продолжить;	КонецЕсли;
		Товар=Новый Структура();
		Товар.Вставить("НоменклатураGUID",СТТовар.Пакет.УникальныйИдентификатор());		
		Если ЗначениеЗаполнено(СТТовар.ХарактеристикаПакета) Тогда
			Если ТипЗнч(СТТовар.ХарактеристикаПакета.Владелец)=Тип("СправочникСсылка.Номенклатура") Тогда
				Товар.Вставить("ХарактеристикаНоменклатурыGUID",СТТовар.ХарактеристикаПакета.УникальныйИдентификатор());
			Иначе
				Товар.Вставить("ХарактеристикаНоменклатурыGUID",СокрЛП(СТТовар.ХарактеристикаПакета.УникальныйИдентификатор())+СокрЛП(СТТовар.Пакет.УникальныйИдентификатор()));
			КонецЕсли;
		Иначе
			Товар.Вставить("ХарактеристикаНоменклатурыGUID","");
		КонецЕсли;
		Товар.Вставить("ИзделиеGUID",СТТовар.Номенклатура.УникальныйИдентификатор());
		Если ЗначениеЗаполнено(СТТовар.ХарактеристикаНоменклатуры) Тогда
			Если ТипЗнч(СТТовар.ХарактеристикаНоменклатуры.Владелец)=Тип("СправочникСсылка.Номенклатура") Тогда
				Товар.Вставить("ХарактеристикаИзделияGUID",СТТовар.ХарактеристикаНоменклатуры.УникальныйИдентификатор());
			Иначе
				Товар.Вставить("ХарактеристикаИзделияGUID",СокрЛП(СТТовар.ХарактеристикаНоменклатуры.УникальныйИдентификатор())+СокрЛП(СТТовар.Номенклатура.УникальныйИдентификатор()));
			КонецЕсли;
		Иначе
			Товар.Вставить("ХарактеристикаИзделияGUID","");
		КонецЕсли;
		Товар.Вставить("Количество",СТТовар.Количество);
		Товар.Вставить("КоличествоИзделий",СТТовар.КоличествоИзделий);
		Товар.Вставить("Коэффициент",1);
		Товар.Вставить("ЕдиницаGUID",СТТовар.Пакет.УникальныйИдентификатор());
		Если СТТовар.Пакет.БЗ_WMS_Дата>=Ссылка.ДокументОснование.Дата ИЛИ НЕ ЗначениеЗаполнено(СТТовар.Пакет.БЗ_WMS_Дата) Тогда
			Товар.Вставить("БезОтбораWMS",Истина);
		Иначе
			Товар.Вставить("БезОтбораWMS",Ложь);
		КонецЕсли;
		МТовары.Добавить(Товар);
	КонецЦикла;
	Документ.Вставить("Товары",МТовары);
	Назначения=Новый Массив();
	Назначения.Добавить(Строка(Ссылка.ДокументОснование.БЗ_Назначение.УникальныйИдентификатор()));
	Документ.Вставить("Назначения", Назначения);
	JSONПакет=Новый Структура();
	JSONПакет.Вставить("Тип","ОжидаемаяОтгрузка");
	JSONПакет.Вставить("КодБД",Узел.КодБД);
	JSONПакет.Вставить("Объект",Документ);
	Возврат ПланыОбмена.БЗ_WMS.Записать_JSON(JSONПакет);
КонецФункции

Функция ПолучитьJSON_ОПС(Ссылка) Экспорт
	Узел=ЭтотОбъект.Ссылка;		
	НСклад=Узел.Склады.Найти(Ссылка.СкладПриемки,"Склад");
	Документ=Новый Структура();		
	Документ.Вставить("GUID",Ссылка.GUID);
	Документ.Вставить("Barcode",Ссылка.КИСBarcode);
	Документ.Вставить("Док","ОПС "+Ссылка.Номер+" ("+Формат(Ссылка.Дата,"ДФ=dd.MM.yyyy")+")");	
	Документ.Вставить("Склад",НСклад.СкладWMS);
	Документ.Вставить("КонтрагентGUID",Ссылка.Участок.УникальныйИдентификатор());
	Документ.Вставить("КонтрагентКод",Ссылка.Участок.Код);
	Документ.Вставить("КонтрагентНаименование",Ссылка.Участок.Наименование);
	Документ.Вставить("КонтрагентНаименованиеПолное",Ссылка.Участок.Наименование);
	Документ.Вставить("Тип","ПроизводствоОПС");
	Документ.Вставить("Проведен",Ссылка.Проведен);
	Документ.Вставить("Комментарий",Ссылка.Комментарий);
	Тбл=Ссылка.ТСД_ВводДанных.Выгрузить();
	Тбл.Свернуть("Номенклатура,ХарактеристикаНоменклатуры,Назначение,НомерПаллеты,ЗНП","Количество");	
	МТовары=Новый Массив();
	Для Каждого СТТовар Из Тбл Цикл
		Товар=Новый Структура();
		Товар.Вставить("НоменклатураGUID",СТТовар.Номенклатура.УникальныйИдентификатор());		
		Если ЗначениеЗаполнено(СТТовар.ХарактеристикаНоменклатуры) Тогда
			Товар.Вставить("ХарактеристикаНоменклатурыGUID",СТТовар.ХарактеристикаНоменклатуры.УникальныйИдентификатор());
		Иначе
			Товар.Вставить("ХарактеристикаНоменклатурыGUID","");
		КонецЕсли;
		Товар.Вставить("НомерПаллеты",СТТовар.НомерПаллеты);
		Товар.Вставить("ЗНП",?(ЗначениеЗаполнено(СТТовар.ЗНП),"ЗНП "+Строка(СТТовар.ЗНП.Номер)+" ("+Строка(СТТовар.ЗНП.Дата)+")",""));
		Товар.Вставить("Количество",СТТовар.Количество);
		Товар.Вставить("Коэффициент",1);
		Товар.Вставить("ЕдиницаGUID",СТТовар.Номенклатура.УникальныйИдентификатор());
		Товар.Вставить("Назначение",?(ЗначениеЗаполнено(СТТовар.Назначение),Строка(СТТовар.Назначение.УникальныйИдентификатор()),""));
		МТовары.Добавить(Товар);
	КонецЦикла;
	Документ.Вставить("Товары",МТовары);
	JSONПакет=Новый Структура();
	JSONПакет.Вставить("Тип","ОПС");
	JSONПакет.Вставить("КодБД",Узел.КодБД);
	JSONПакет.Вставить("Объект",Документ);
	Возврат ПланыОбмена.БЗ_WMS.Записать_JSON(JSONПакет);
КонецФункции

// -----
Процедура ЗавершитьСессию() Экспорт
	Если ПараметрыСеанса.БЗ_WMS_Обмен_Сессия="" Тогда
		Возврат;
	КонецЕсли;
	Узел=ЭтотОбъект.Ссылка;
	Соединение = Новый HTTPСоединение(Узел.АдресСервера);
    HTTPЗапрос = Новый HTTPЗапрос("/"+Узел.НазваниеБД+"/hs/exchange/json_api");
    HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");
	HTTPЗапрос.Заголовки.Вставить("IBSession", "finish");
	HTTPЗапрос.Заголовки.Вставить("Cookie", ПараметрыСеанса.БЗ_WMS_Обмен_Сессия);
	HTTPЗапрос.УстановитьТелоИзСтроки("",КодировкаТекста.ANSI);
	HTTPОтвет=Соединение.ОтправитьДляОбработки(HTTPЗапрос);	
	ПараметрыСеанса.БЗ_WMS_Обмен_Сессия="";
КонецПроцедуры

Функция ВыполнитьОтправкуJSONПакета(JSONПакет,JSONОтвет=Неопределено) Экспорт
	Узел=ЭтотОбъект.Ссылка;
	Размер=СтрДлина(JSONПакет);
	Попытка
		ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик=ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик+Размер;
	Исключение
		ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик=Размер;
		ПараметрыСеанса.БЗ_WMS_Обмен_Сессия="";
	КонецПопытки;
	Если ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик>52428800 И ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик<>Размер Тогда // За один запуск отправляем не более 50мб, кроме первого пакета в сеансе
		Возврат "limit_out";
	КонецЕсли;	
	ИмяПубликации="WMS";
	Если СокрЛП(Узел.НазваниеБД)<>"" Тогда
		ИмяПубликации=Узел.НазваниеБД;
	КонецЕсли;
	Если ПараметрыСеанса.БЗ_WMS_Обмен_Сессия="" Тогда
		Соединение = Новый HTTPСоединение(Узел.АдресСервера);
    	HTTPЗапрос = Новый HTTPЗапрос("/"+ИмяПубликации+"/hs/exchange/json_api");
    	HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");
		HTTPЗапрос.Заголовки.Вставить("IBSession", "start");
		HTTPЗапрос.УстановитьТелоИзСтроки("",КодировкаТекста.ANSI);
		HTTPОтвет=Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		Cookie=HTTPОтвет.Заголовки.Получить("Set-Cookie");
		Если Cookie=Неопределено Тогда
			Возврат "request_error";
		КонецЕсли;
		ПараметрыСеанса.БЗ_WMS_Обмен_Сессия=Cookie;
	КонецЕсли;	
	Соединение = Новый HTTPСоединение(Узел.АдресСервера);
    HTTPЗапрос = Новый HTTPЗапрос("/"+ИмяПубликации+"/hs/exchange/json_api");
    HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");	
	HTTPЗапрос.Заголовки.Вставить("Cookie", ПараметрыСеанса.БЗ_WMS_Обмен_Сессия);	
	HTTPЗапрос.УстановитьТелоИзСтроки(JSONПакет,КодировкаТекста.ANSI);
	HTTPОтвет=Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Ответ=HTTPОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	Попытка
		JSONОтвет=ПланыОбмена.БЗ_WMS.Прочитать_JSON(Ответ);
		Если JSONОтвет.status="need_objects" И ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик=Размер Тогда // Если 1-й объект-документ большой - то оставить место для отправки объектов которых не хватает в лимите;
			Если ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик>50000000 Тогда
				ПараметрыСеанса.БЗ_WMS_Обмен_Счетчик=40000000;
			КонецЕсли;
		КонецЕсли;
		Возврат JSONОтвет.status;
	Исключение
		Если Найти(Ответ,"Сеанс отсутствует")=0 Тогда		
			ЗаписьЖурналаРегистрации("Обмен_Производство",УровеньЖурналаРегистрации.Ошибка,,Ответ,"request_error",РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
			Возврат "request_error";
		КонецЕсли;
	КонецПопытки;
	ПараметрыСеанса.БЗ_WMS_Обмен_Сессия="";
	ВыполнитьОтправкуJSONПакета(JSONПакет,JSONОтвет); // Переинициализация мертвой сессии
	//Узел=ЭтотОбъект.Ссылка;
	//Соединение = Новый HTTPСоединение(Узел.АдресСервера);
	//ИмяПубликации="WMS";
	//Если СокрЛП(Узел.НазваниеБД)<>"" Тогда
	//	ИмяПубликации=Узел.НазваниеБД;
	//КонецЕсли;
	//HTTPЗапрос = Новый HTTPЗапрос("/"+ИмяПубликации+"/hs/exchange/json_api"); 
	//HTTPЗапрос.Заголовки.Вставить("Content-type", "application/json");
	//HTTPЗапрос.УстановитьТелоИзСтроки(JSONПакет,КодировкаТекста.ANSI);
	//HTTPОтвет=Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	//Ответ=HTTPОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	//Попытка
	//	JSONОтвет=ПланыОбмена.БЗ_WMS.Прочитать_JSON(Ответ);
	//	Возврат JSONОтвет.status;
	//Исключение
	//	Возврат "request_error";
	//КонецПопытки
КонецФункции

Функция Получить_БЗ_Принтеры(Ссылка) Экспорт
	Если Ссылка.ЭтоГруппа Тогда Возврат Получить_ГруппаУниверсальная(Ссылка); КонецЕсли;
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);
	Данные.Вставить("Размещение",Ссылка.Размещение);	
	Данные.Вставить("Комментарий",Ссылка.Комментарий);	
	Родитель=Новый Структура();
	Данные.Вставить("Родитель",Родитель);
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=Данные.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		СТРодитель.Вставить("GUID",СсылкаНаОбъект(ТКРодитель));
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);		
		ТКРодитель=ТКРодитель.Родитель;
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;
	Данные.Вставить("ПутьПечати",Ссылка.ПутьПечати);
	Данные.Вставить("ТипПечати",ИмяПеречисления(Ссылка.ТипПечати));
	Данные.Вставить("Участок",СсылкаНаОбъект(Ссылка.Участок));
	Данные.Вставить("Подразделение",СсылкаНаОбъект(Ссылка.Подразделение));
	Возврат Данные;
КонецФункции

Функция Получить_БЗ_Участки(Ссылка) Экспорт
	Если Ссылка.ЭтоГруппа Тогда Возврат Получить_ГруппаУниверсальная(Ссылка); КонецЕсли;
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);	
	Родитель=Новый Структура();
	Данные.Вставить("Родитель",Родитель);	
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=Данные.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		СТРодитель.Вставить("GUID",СсылкаНаОбъект(ТКРодитель));
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);
		ТКРодитель=ТКРодитель.Родитель;
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;
	Возврат Данные;
КонецФункции

Функция Получить_Подразделения(Ссылка) Экспорт
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Новый Структура("GUID","");
	КонецЕсли;	
	ДобавитьОбъектВОтправленые(Ссылка);
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);
	Родитель=Новый Структура();
	Данные.Вставить("Родитель",Родитель);
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=Данные.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		ДобавитьОбъектВОтправленые(ТКРодитель);
		СТРодитель.Вставить("GUID",СсылкаНаОбъект(ТКРодитель));
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);		
		ТКРодитель=ТКРодитель.Родитель;
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;
	Возврат Данные;
КонецФункции

Функция Получить_БЗ_Назначения(Ссылка) Экспорт
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);
	Возврат Данные;
КонецФункции

Функция Получить_БЗ_Сотрудники_ТСД(Ссылка) Экспорт
	Если Ссылка.ЭтоГруппа Тогда Возврат Получить_ГруппаУниверсальная(Ссылка); КонецЕсли;
	Данные=Новый Структура();
	Данные.Вставить("GUID",СсылкаНаОбъект(Ссылка));
	Данные.Вставить("Код",Ссылка.Код);
	Данные.Вставить("Наименование",Ссылка.Наименование);
	Родитель=Новый Структура();
	Данные.Вставить("Родитель",Родитель);
	ТКРодитель=Ссылка.Родитель;
	СТРодитель=Данные.Родитель;
	Пока ЗначениеЗаполнено(ТКРодитель) Цикл
		СТРодитель.Вставить("GUID",СсылкаНаОбъект(ТКРодитель));
		СТРодитель.Вставить("Код",ТКРодитель.Код);
		СТРодитель.Вставить("Наименование",ТКРодитель.Наименование);		
		ТКРодитель=ТКРодитель.Родитель;
		Если ЗначениеЗаполнено(ТКРодитель) Тогда
			Родитель=Новый Структура();
			СТРодитель.Вставить("Родитель",Родитель);
			СТРодитель=СТРодитель.Родитель;
		КонецЕсли;
	КонецЦикла;
	Данные.Вставить("ПинКод",Ссылка.ПинКод);
	Данные.Вставить("СканКод",Ссылка.СканКод);
	//Данные.Вставить("Доступ_РедакцияОПС",Ссылка.Доступ_РедакцияОПС);
	//Данные.Вставить("ПредупреждатьОУчетеПоСН",Ссылка.ПредупреждатьОУчетеПоСН);
	//Данные.Вставить("ПередачаТЕ",Ссылка.ПередачаТЕ);
	//МТСД_ВидыОпераций=Новый Массив();
	//Для Каждого Строка Из Ссылка.ТСД_ВидыОпераций Цикл
	//	ТСД_ВидыОпераций=Новый Структура();
	//	ТСД_ВидыОпераций.Вставить("Операция",ИмяПеречисления(Строка.Операция));
	//	МТСД_ВидыОпераций.Добавить(ТСД_ВидыОпераций);
	//КонецЦикла;
	//МУчастки=Новый Массив();
	//Для Каждого Строка Из Ссылка.Участки Цикл
	//	Участки=Новый Структура();
	//	Участки.Вставить("Участок",СсылкаНаОбъект(Строка.Участок));
	//	Участки.Вставить("РабочееМесто",СсылкаНаОбъект(Строка.РабочееМесто));
	//	Участки.Вставить("Ответственный",СсылкаНаОбъект(Строка.Ответственный));
	//	Участки.Вставить("НомерБригады",Строка.НомерБригады);
	//	//Участки.Вставить("РаботникБригада",СсылкаНаОбъект(Строка.РаботникБригада));
	//	МУчастки.Добавить(Участки);
	//КонецЦикла;
	////Данные.Вставить("ТСД_ВидыОпераций",МТСД_ВидыОпераций);
	//Данные.Вставить("Участки",МУчастки);
	Возврат Данные;
КонецФункции

