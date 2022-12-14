Функция Лог(Событие,Уровень, Данные,Комментарий="") Экспорт
	// Для замера производительности расчета
	ЗаписьЖурналаРегистрации(Событие,Уровень,,Данные,Комментарий,РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
КонецФункции

Функция ПолучитьПараметр(УзелОбъект = Неопределено, Параметр) Экспорт
	КодПараметра = СокрЛП(УзелОбъект.Код)+" | "+Параметр;
	Возврат РегистрыСведений.БЗ_MES_Параметры.Получить(Новый Структура("Параметр",КодПараметра));
КонецФункции

Процедура ЗаписатьПараметр(УзелОбъект = Неопределено, Параметр, Значение) Экспорт
	Если УзелОбъект <> Неопределено Тогда
		КодПараметра = СокрЛП(УзелОбъект.Код)+" | ";
	Иначе
		КодПараметра = "";
	КонецЕсли;
	МПараметр=РегистрыСведений.БЗ_MES_Параметры.СоздатьМенеджерЗаписи();
	МПараметр.Параметр=КодПараметра+Параметр;
	МПараметр.Значение=Значение;
	МПараметр.Записать(Истина);
КонецПроцедуры

// ---- Экспорт ----

Функция Экспорт_Номенклатура(УзелОбъект)
	Запрос=Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Номенклатура.Изменения ГДЕ Узел=&Узел");	
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	ОбменНоменклатура=Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой); // Таблица регистраций на узле
	Запрос=Новый Запрос("ВЫБРАТЬ Ссылка.Владелец КАК Владелец,Ссылка ИЗ Справочник.ХарактеристикиНоменклатуры.Изменения ГДЕ Узел=&Узел");
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		Если ОбменНоменклатура.Найти(Выборка.Владелец,"Ссылка")=Неопределено Тогда   
			Попытка
			ПланыОбмена.ЗарегистрироватьИзменения(УзелОбъект.Ссылка,Выборка.Владелец);
		Исключение   
				Лог("Ошибка регистрации на обмен", УровеньЖурналаРегистрации.Ошибка, Выборка.Владелец);
			КонецПопытки;
		КонецЕсли;
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
	КонецЦикла;	
	Запрос=Новый Запрос("ВЫБРАТЬ Ссылка.Владелец КАК Владелец,Ссылка ИЗ Справочник.ЕдиницыИзмерения.Изменения ГДЕ Узел=&Узел");
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		Если ОбменНоменклатура.Найти(Выборка.Владелец,"Ссылка")=Неопределено Тогда
			Если ТипЗнч(Выборка.Владелец()) = Тип("СправочникСсылка.Номенклатура") Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(УзелОбъект.Ссылка,Выборка.Владелец);
			Иначе
				ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
			КонецЕсли;
		КонецЕсли;
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
	КонецЦикла;
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ШтрихкодыНоменклатуры");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	ШтрихкодыНоменклатуры.Номенклатура КАК Владелец
	                    |ИЗ
	                    |	РегистрСведений.ШтрихкодыНоменклатуры.Изменения КАК ШтрихкодыНоменклатурыИзменения
	                    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	                    |		ПО ШтрихкодыНоменклатурыИзменения.Штрихкод = ШтрихкодыНоменклатуры.Штрихкод
	                    |ГДЕ
	                    |	ШтрихкодыНоменклатурыИзменения.Узел = &Узел
	                    |
	                    |СГРУППИРОВАТЬ ПО
	                    |	ШтрихкодыНоменклатуры.Номенклатура");
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		Если ОбменНоменклатура.Найти(Выборка.Владелец,"Ссылка")=Неопределено Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(УзелОбъект.Ссылка,Выборка.Владелец);
		КонецЕсли;
	КонецЦикла;
	Запрос=Новый Запрос("ВЫБРАТЬ
	|	ШтрихкодыНоменклатурыИзменения.Штрихкод КАК Штрихкод,
	|	ШтрихкодыНоменклатурыИзменения.Номенклатура КАК Номенклатура,
	|	ШтрихкодыНоменклатурыИзменения.Характеристика КАК Характеристика,
	|	ШтрихкодыНоменклатурыИзменения.Партия КАК Партия,
	|	ШтрихкодыНоменклатурыИзменения.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры.Изменения КАК ШтрихкодыНоменклатурыИзменения
	|ГДЕ
	|	ШтрихкодыНоменклатурыИзменения.Узел = &Узел");
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		Набор = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
		Набор.Отбор.Штрихкод.Установить(Выборка.Штрихкод);
		Набор.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
		Набор.Отбор.Характеристика.Установить(Выборка.Характеристика);
		Набор.Отбор.Партия.Установить(Выборка.Партия);
		Набор.Отбор.ЕдиницаИзмерения.Установить(Выборка.ЕдиницаИзмерения);
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Набор);		
	КонецЦикла;	
	ЗафиксироватьТранзакцию();
	Запрос=Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Номенклатура.Изменения ГДЕ Узел=&Узел");	
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		//Если НЕ УзелОбъект.ОбъектОтправлен(Выборка.Ссылка) Тогда
		//	 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
		//	 Продолжить;
		//КонецЕсли;
		JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(УзелОбъект.ПолучитьJSON_Номенклатура(Выборка.Ссылка)); 
		СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос);
		Если СтатусОтвета="ok" Тогда
			 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
		ИначеЕсли СтатусОтвета="limit_out" Тогда
			 Возврат Ложь;
		КонецЕсли;
		JSONЗапрос=Неопределено;
	КонецЦикла;	
	Возврат Истина;
КонецФункции

Функция Экспорт_Справочник(УзелОбъект,Справочник,ТолькоВыгруженные=Ложь)
	Запрос=Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник."+Справочник+".Изменения ГДЕ Узел=&Узел");	
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Ссылка.ПолучитьОбъект()=Неопределено Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		Если ТолькоВыгруженные Тогда
			Если НЕ УзелОбъект.ОбъектОтправлен(Выборка.Ссылка) Тогда
				 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
				 Продолжить;
			КонецЕсли;
		КонецЕсли;
		Ответ="";
		JSONПакет=Новый Структура();
		Если Выборка.Ссылка.ЭтоГруппа Тогда
			JSONПакет.Вставить("Тип",Справочник+"_Группа");			
		Иначе
			JSONПакет.Вставить("Тип",Справочник);
		КонецЕсли;
		Выполнить("JSONПакет.Вставить(""Объект"",УзелОбъект.Получить_"+Справочник+"(Выборка.Ссылка))");
		JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет);
		JSONПакет=Неопределено;
		СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
		JSONЗапрос=Неопределено;
		Если СтатусОтвета="ok" Тогда
			 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
		ИначеЕсли СтатусОтвета="need_objects" Тогда
			 Если НЕ ОтправитьНенайденыеОбъекты(УзелОбъект, Ответ.НенайденыОбъекты) Тогда
				 Возврат Ложь;
			 КонецЕсли;			 
			 СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
			 Если СтатусОтвета="ok" Тогда
				 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
			 ИначеЕсли СтатусОтвета="limit_out" Тогда
				 Возврат Ложь;				 
			 КонецЕсли;
		ИначеЕсли СтатусОтвета="limit_out" Тогда
			 Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

Функция Экспорт_Документ(УзелОбъект,Документ,ТолькоВыгруженные=Ложь)
	Запрос=Новый Запрос("ВЫБРАТЬ "+Документ+".Ссылка ИЗ Документ."+Документ+".Изменения КАК "+Документ+" ГДЕ Узел=&Узел УПОРЯДОЧИТЬ ПО "+Документ+".Ссылка.Дата");
	Запрос.Параметры.Вставить("Узел",УзелОбъект.Ссылка);
	Выборка=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Ссылка.ПолучитьОбъект()=Неопределено Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		Если ТолькоВыгруженные Тогда
			Если НЕ УзелОбъект.ОбъектОтправлен(Выборка.Ссылка) Тогда
				 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
				 Продолжить;
			КонецЕсли;
		КонецЕсли;		
		Ответ="";
		JSONПакет=Новый Структура();
		JSONПакет.Вставить("Тип",Документ);
		Выполнить("JSONПакет.Вставить(""Объект"",УзелОбъект.Получить_"+Документ+"(Выборка.Ссылка))");
		JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет);
		JSONПакет=Неопределено;
		СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
		JSONЗапрос=Неопределено;
		Если СтатусОтвета="ok" Тогда
			 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
		ИначеЕсли СтатусОтвета="need_objects" Тогда
			 Если НЕ ОтправитьНенайденыеОбъекты(УзелОбъект, Ответ.НенайденыОбъекты) Тогда
				 Возврат Ложь;
			 КонецЕсли;			 
			 СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
			 Если СтатусОтвета="ok" Тогда
				 ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,Выборка.Ссылка);
			 ИначеЕсли СтатусОтвета="limit_out" Тогда
				 Возврат Ложь;				 
			 КонецЕсли;
		ИначеЕсли СтатусОтвета="limit_out" Тогда
			 Возврат Ложь;			 
		КонецЕсли;
	КонецЦикла;	
	Возврат Истина;
КонецФункции

Процедура Экспорт_ТоварыВПроизводстве(УзелОбъект)
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Документ.СборкаЗапасов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки = Блокировка.Добавить("Документ.БЗ_ОПС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	Запрос=Новый Запрос();
	Запрос.Текст="ВЫБРАТЬ
	|	ОстаткиПроизводства.Номенклатура КАК Номенклатура,
	|	ОстаткиПроизводства.Характеристика КАК Характеристика,
	|	ОстаткиПроизводства.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ОстаткиПроизводства.Назначение КАК Назначение,
	|	СУММА(ОстаткиПроизводства.Количество) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыНаПроизводство.Номенклатура КАК Номенклатура,
	|		ЗаказыНаПроизводство.Характеристика КАК Характеристика,
	|		ЗаказыНаПроизводство.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|		ЗаказыНаПроизводство.КоличествоОстаток КАК Количество,
	|		ЗаказыНаПроизводство.Назначение КАК Назначение
	|	ИЗ
	|		РегистрНакопления.БЗ_ОстаткиНазначений.Остатки(
	|				,
	|				ЗаказНаПроизводство.Дата > &ДатаВидимости
	|					И ЗаказНаПроизводство.Проведен = ИСТИНА) КАК ЗаказыНаПроизводство
	|	ГДЕ
	|		ЗаказыНаПроизводство.Номенклатура.Изготовитель <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаказыНаПроизводство.Номенклатура,
	|		ЗаказыНаПроизводство.Характеристика,
	|		ЗаказыНаПроизводство.ЗаказНаПроизводство,
	|		ЗаказыНаПроизводство.Количество,
	|		ЗаказыНаПроизводство.Назначение
	|	ИЗ
	|		Документ.БЗ_ОПС КАК БЗ_ОПС
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_ОПС.ПриемкиТоваров КАК БЗ_ОПСПриемкиТоваров
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БЗ_ОстаткиНазначений КАК ЗаказыНаПроизводство
	|				ПО БЗ_ОПСПриемкиТоваров.ПриемкаТоваров = ЗаказыНаПроизводство.Регистратор
	|			ПО БЗ_ОПС.Ссылка = БЗ_ОПСПриемкиТоваров.Ссылка
	|	ГДЕ
	|		НЕ БЗ_ОПС.ПринятоНаСкладе
	|		И НЕ ЗаказыНаПроизводство.Номенклатура ЕСТЬ NULL) КАК ОстаткиПроизводства
	|ГДЕ
	|	ОстаткиПроизводства.Количество > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиПроизводства.Номенклатура,
	|	ОстаткиПроизводства.Характеристика,
	|	ОстаткиПроизводства.ЗаказНаПроизводство,
	|	ОстаткиПроизводства.Назначение";
	Запрос.УстановитьПараметр("ДатаВидимости", НачалоДня(ТекущаяДата())-60*60*24*240); // 240 дней	
	ВыборкаОстатки=Запрос.Выполнить().Выбрать();
	ПолученыНаСкладеОПС=Новый Массив();
	ОтправленыеОПС=Новый Массив();
	Запрос=Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БЗ_ОПС.Ссылка,
	|	БЗ_ОПС.Ссылка.ПринятоНаСкладе КАК ПринятоНаСкладе,
	|	БЗ_ОПС.Ссылка.GUID КАК GUID
	|ИЗ
	|	Документ.БЗ_ОПС.Изменения КАК БЗ_ОПС
	|ГДЕ
	|	БЗ_ОПС.Узел = &Узел";
	Запрос.УстановитьПараметр("Узел",УзелОбъект.Ссылка);
	ВыборкаОПС=Запрос.Выполнить().Выбрать();
	Пока ВыборкаОПС.Следующий() Цикл
		Попытка
			Если ВыборкаОПС.ПринятоНаСкладе Тогда
				ПолученыНаСкладеОПС.Добавить(ВыборкаОПС.GUID);
				ОтправленыеОПС.Добавить(ВыборкаОПС.Ссылка);
			КонецЕсли;
		Исключение
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,ВыборкаОПС.Ссылка);
		КонецПопытки;
	КонецЦикла;	
	ЗафиксироватьТранзакцию();
	Остатки=Новый Массив();
	Пока ВыборкаОстатки.Следующий() Цикл
		Остатки.Добавить(
			Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, ЗаказНаПроизводство, Назначение, Количество",
			УзелОбъект.СсылкаНаОбъект(ВыборкаОстатки.Номенклатура),
			УзелОбъект.СсылкаНаОбъект(ВыборкаОстатки.Характеристика),
			УзелОбъект.СсылкаНаОбъект(ВыборкаОстатки.ЗаказНаПроизводство),
			УзелОбъект.СсылкаНаОбъект(ВыборкаОстатки.Назначение),
			ВыборкаОстатки.Количество));
	КонецЦикла;	
	JSONПакет=Новый Структура();
	JSONПакет.Вставить("Тип","ТоварыВПроизводстве");
	JSONПакет.Вставить("Остатки",Остатки);
	JSONПакет.Вставить("ПолученыНаСкладеОПС",ПолученыНаСкладеОПС);
	JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет);
	Ответ="";
	СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
	Если СтатусОтвета="need_objects" Тогда
		Если НЕ ОтправитьНенайденыеОбъекты(УзелОбъект, Ответ.НенайденыОбъекты) Тогда
			Возврат;
		Иначе
			СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
		КонецЕсли;		
	КонецЕсли;
	Если СтатусОтвета="ok" Тогда
		Для Каждого ОПС Из ОтправленыеОПС Цикл
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбъект.Ссылка,ОПС);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ОтправитьНенайденыеОбъекты(УзелОбъект, СписокОбъектов, Знач Уровень=1)
	Для Каждого Объект Из СписокОбъектов Цикл		
		Тип=Объект.Тип;
		Если Тип="Подразделения" Тогда
			Ссылка=Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор(Объект.GUID)).ПолучитьОбъект().Ссылка;
			Если Ссылка.ЭтоГруппа Тогда	Тип=Объект.Тип+"_Группа"; КонецЕсли;
		ИначеЕсли Тип="Склады" Тогда
			Ссылка=Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор(Объект.GUID)).ПолучитьОбъект().Ссылка;
			Если Ссылка.ЭтоГруппа Тогда	Тип=Объект.Тип+"_Группа"; КонецЕсли;
		Иначе			
			Попытка
				Ссылка=Справочники[Объект.Тип].ПолучитьСсылку(Новый УникальныйИдентификатор(Объект.GUID)).ПолучитьОбъект().Ссылка;
				Если Ссылка.ЭтоГруппа Тогда
					Тип=Объект.Тип+"_Группа";
				КонецЕсли;			
			Исключение
				Попытка
					Ссылка=Документы[Объект.Тип].ПолучитьСсылку(Новый УникальныйИдентификатор(Объект.GUID)).ПолучитьОбъект().Ссылка;
				Исключение
					Продолжить;
				КонецПопытки;
			КонецПопытки;
		КонецЕсли;
		Если ТипЗнч(Ссылка)=Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
			Ссылка=Ссылка.Владелец;
			Объект.Тип="Номенклатура";
			Тип="Номенклатура";
		ИначеЕсли ТипЗнч(Ссылка)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
			Ссылка=Ссылка.Владелец;
			Объект.Тип="Номенклатура";
			Тип="Номенклатура";
		КонецЕсли;		
		Ответ="";
		JSONПакет=Новый Структура();
		JSONПакет.Вставить("Тип",Тип);
		Выполнить("JSONПакет.Вставить(""Объект"",УзелОбъект.Получить_"+Объект.Тип+"(Ссылка))");
		JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет);
		СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
		Если СтатусОтвета="need_objects" Тогда
			 Если Уровень=5 Тогда Возврат Истина; КонецЕсли; // На случай рекурсионной зацикленности
			 Если НЕ ОтправитьНенайденыеОбъекты(УзелОбъект, Ответ.НенайденыОбъекты, Уровень+1) Тогда
				 Возврат Ложь;
			 КонецЕсли;
			 СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
		ИначеЕсли СтатусОтвета="limit_out" Тогда
			 Возврат Ложь;			 
		КонецЕсли;			
	КонецЦикла;
	Возврат Истина;
КонецФункции

// ---- Импорт ----

Процедура Импорт_БЗ_ОПС(УзелОбъект)
	КоличествоОбъектов=3;
	Пока КоличествоОбъектов=3 Цикл
		ПринятыеОбъекты=Новый Массив();
		Ответ="";	
		JSONПакет=Новый Структура();
		JSONПакет.Вставить("Тип","Экспорт_БЗ_ОПС");
		JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет);		
		СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос,Ответ);
		Если СтатусОтвета="ok" Тогда
			КоличествоОбъектов=Ответ.Объекты.Количество();			
			Для Каждого Данные Из Ответ.Объекты Цикл
				Если ЗначениеЗаполнено(УзелОбъект.НайтиСоздатьБЗ_ОПС(Данные))Тогда
					ПринятыеОбъекты.Добавить(Данные.GUID);
				КонецЕсли;
			КонецЦикла;
			Для Каждого GUID Из Ответ.НепринятыеОПС Цикл
				Запрос=Новый Запрос("ВЫБРАТЬ
				                    |	БЗ_ОПС.Ссылка,
				                    |	БЗ_ОПС.ПринятоНаСкладе
				                    |ИЗ
				                    |	Документ.БЗ_ОПС КАК БЗ_ОПС
				                    |ГДЕ
				                    |	БЗ_ОПС.УзелОбмена = &УзелОбмена
				                    |	И БЗ_ОПС.GUID = &GUID");
				Запрос.УстановитьПараметр("УзелОбмена",УзелОбъект.Ссылка);
				Запрос.УстановитьПараметр("GUID",GUID);
				Выборка=Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					Если Выборка.ПринятоНаСкладе Тогда
						ПланыОбмена.ЗарегистрироватьИзменения(УзелОбъект.Ссылка,Выборка.Ссылка);
						ЗаписатьПараметр(УзелОбъект,"Обмен_45_ТоварыВПроизводстве", ТекущаяДата()-1200);
					Иначе
						Запрос=Новый Запрос();
						Запрос.Текст =
						"ВЫБРАТЬ
						|	План.НомерПаллеты
						|ИЗ
						|	(ВЫБРАТЬ
						|		ТСД_ВводДанных.НомерПаллеты КАК НомерПаллеты
						|	ИЗ
						|		Документ.БЗ_ОПС.ТСД_ВводДанных КАК ТСД_ВводДанных
						|	ГДЕ
						|		ТСД_ВводДанных.Ссылка = &Ссылка
						|	
						|	СГРУППИРОВАТЬ ПО
						|		ТСД_ВводДанных.НомерПаллеты) КАК План
						|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
						|			ПриемкиТоваров.НомерПаллеты КАК НомерПаллеты
						|		ИЗ
						|			Документ.БЗ_ОПС.ПриемкиТоваров КАК ПриемкиТоваров
						|		ГДЕ
						|			ПриемкиТоваров.Ссылка = &Ссылка
						|		
						|		СГРУППИРОВАТЬ ПО
						|			ПриемкиТоваров.НомерПаллеты) КАК Факт
						|		ПО План.НомерПаллеты = Факт.НомерПаллеты
						|ГДЕ
						|	Факт.НомерПаллеты ЕСТЬ NULL";
						Запрос.УстановитьПараметр("Ссылка",Выборка.Ссылка);
						Если Запрос.Выполнить().Пустой() Тогда
							ОПС=Выборка.Ссылка.ПолучитьОбъект();
							ОПС.ПринятоНаСкладе=Истина;
							ОПС.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
							ЗаписатьПараметр(УзелОбъект,"Обмен_45_ТоварыВПроизводстве", ТекущаяДата()-1200);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Прервать;
		КонецЕсли;
		Если ПринятыеОбъекты.Количество()>0  Тогда
			JSONПакет=Новый Структура();
			JSONПакет.Вставить("Тип","Принято_БЗ_ОПС");
			JSONПакет.Вставить("ПринятыеОбъекты",ПринятыеОбъекты);
			JSONЗапрос=ПланыОбмена.БЗ_MES.Записать_JSON(JSONПакет);
			СтатусОтвета=УзелОбъект.ВыполнитьОтправкуJSONПакета(JSONЗапрос);
			Если СтатусОтвета<>"ok" Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

// ---- Основные ----

Функция ВыполнитьОбменУзла(УзелОбъект)
// Экспорт ->>>
	ЗаписатьПараметр(УзелОбъект,"Обмен_00_Запуск", ТекущаяДата());

// Справочники
	Если НЕ Экспорт_Номенклатура(УзелОбъект) Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_Участки") Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_РабочиеМеста") Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_ВариантыНаладки") Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_ТехнологическиеОперации") Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_ТипыТЕ") Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_ТипыДвижений_ТСД") Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_ВидыПартииПроизводства") Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_Сотрудники_ТСД") Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"БЗ_Принтеры") Тогда Возврат Ложь; КонецЕсли;
	
// Только выгруженные объекты
	Если НЕ Экспорт_Справочник(УзелОбъект,"Организации",Истина) Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"Подразделения",Истина) Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"Пользователи",Истина) Тогда Возврат Ложь; КонецЕсли;
	Если НЕ Экспорт_Справочник(УзелОбъект,"КлассификаторЕдиницИзмерения",Истина) Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"ФизическиеЛица",Истина) Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"Склады",Истина) Тогда Возврат Ложь; КонецЕсли;
	//Если НЕ Экспорт_Справочник(УзелОбъект,"СтруктурныеЕдиницы",Истина) Тогда Возврат Ложь; КонецЕсли;	
	//Если НЕ Экспорт_Справочник(УзелОбъект,"НоменклатурныеГруппы",Истина) Тогда Возврат Ложь; КонецЕсли;
	
	ДатаЭкспорта=ПолучитьПараметр(УзелОбъект,"Обмен_45_ТоварыВПроизводстве");
	Если ДатаЭкспорта.Значение=Неопределено Тогда
		Экспорт_ТоварыВПроизводстве(УзелОбъект);
		ЗаписатьПараметр(УзелОбъект,"Обмен_45_ТоварыВПроизводстве", ТекущаяДата());
	ИначеЕсли ДатаЭкспорта.Значение<ТекущаяДата()-60*5 Тогда
		Экспорт_ТоварыВПроизводстве(УзелОбъект);
		ЗаписатьПараметр(УзелОбъект,"Обмен_45_ТоварыВПроизводстве", ТекущаяДата());
	КонецЕсли;

	ЗаписатьПараметр(УзелОбъект,"Обмен_49_ЭкспортОкончание", ТекущаяДата());
	
// <<- Импорт
	Импорт_БЗ_ОПС(УзелОбъект);
	ЗаписатьПараметр(УзелОбъект,"Обмен_99_ИмпортОкончание", ТекущаяДата());
	
	Возврат Истина;
КонецФункции

Процедура ВыполнитьОбмен() Экспорт
	ПараметрыСеанса.БЗ_MES_Обмен_Счетчик=0;
	Выборка=ПланыОбмена.БЗ_MES.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Активирован Тогда
			ПараметрыСеанса.БЗ_MES_Обмен_Сессия="";			
			УзелОбъект=Выборка.Ссылка.ПолучитьОбъект();
			Если НЕ ВыполнитьОбменУзла(УзелОбъект) Тогда
				УзелОбъект.ЗавершитьСессию();
				Прервать;
			КонецЕсли;
			УзелОбъект.ЗавершитьСессию();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры