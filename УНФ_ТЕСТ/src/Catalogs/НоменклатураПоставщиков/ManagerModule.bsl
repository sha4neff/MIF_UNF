
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Процедура для перехода на новый механизм сопоставления номенклатуры БЭД, 
// переносить данные из Справочник.Номенклатура поставщика в РегистрыСведений.НоменклатураКонтрагентовБЭД.
Процедура ПеренестиНоменклатуруПоставщиковВРегистрБЭД(Параметры) Экспорт
	
	Пока Истина Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	НоменклатураПоставщиков.Владелец КАК Владелец,
		|	МАКСИМУМ(НоменклатураПоставщиков.Номенклатура) КАК Номенклатура,
		|	МАКСИМУМ(НоменклатураПоставщиков.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(НоменклатураПоставщиков.Артикул) КАК Артикул,
		|	НоменклатураПоставщиков.Идентификатор КАК Идентификатор,
		|	МАКСИМУМ(НоменклатураКонтрагентовБЭД.Номенклатура) КАК СопоставленнаяНоменклатура,
		|	МАКСИМУМ(НоменклатураПоставщиков.Наименование) КАК Наименование
		|ИЗ
		|	Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
		|		ПО НоменклатураПоставщиков.Владелец = НоменклатураКонтрагентовБЭД.Владелец
		|			И НоменклатураПоставщиков.Идентификатор = НоменклатураКонтрагентовБЭД.Идентификатор
		|ГДЕ
		|	НоменклатураПоставщиков.Владелец <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|	И НоменклатураПоставщиков.Идентификатор <> """"
		|	И НоменклатураКонтрагентовБЭД.Номенклатура ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	НоменклатураПоставщиков.Идентификатор,
		|	НоменклатураПоставщиков.Владелец
		|ИТОГИ ПО
		|	Владелец";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Прервать;
		КонецЕсли;
		ВыборкаПоВладельцу = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоВладельцу.Следующий() Цикл
			Набор = РегистрыСведений.НоменклатураКонтрагентовБЭД.СоздатьНаборЗаписей();
			Набор.Отбор.Владелец.Установить(ВыборкаПоВладельцу.Владелец);
			Набор.Прочитать();
			Выборка = ВыборкаПоВладельцу.Выбрать();
			Пока Выборка.Следующий() Цикл
				Запись = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Выборка);
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
		КонецЦикла;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
		
КонецПроцедуры

Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	//
	// Для группы полей действует правило: хотя бы одно поле в группе должно быть выбрано в колонках
	//
	
	ОписаниеТиповСтрока10 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(10));
	ОписаниеТиповСтрока11 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(11));
	ОписаниеТиповСтрока19 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(19));
	ОписаниеТиповСтрока25 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(25));
	ОписаниеТиповСтрока50 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100));
	ОписаниеТиповСтрока110 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(110));
	ОписаниеТиповСтрока150 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	ОписаниеТиповСтрока200 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
	ОписаниеТиповСтрока1000 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(1000));
	ОписаниеТиповСтрока0000 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(0));
	ОписаниеТиповЧисло10_0 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповЧисло10_3 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповЧисло15_2 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповДата = Новый ОписаниеТипов("Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.НоменклатураПоставщиков");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Родитель", "Группа", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, , , , );
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.НоменклатураПоставщиков");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "АртикулПоставщика", "Артикул поставщика", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "НоменклатураПоставщиков", 1, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ИдентификаторПоставщика","Идентификатор поставщика", ОписаниеТиповСтрока110, ОписаниеТиповКолонка, "НоменклатураПоставщиков", 2, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураПоставщиковНаименование", "Номенклатура поставщиков (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "НоменклатураПоставщиков", 3, , Истина);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Код", 		"Код", 			ОписаниеТиповСтрока11, ОписаниеТиповКолонка, "Номенклатура", 1);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Штрихкод", 	"Штрихкод", 	ОписаниеТиповСтрока200, ОписаниеТиповКолонка, "Номенклатура", 2);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Артикул", 	"Номенклатура (артикул)", 		ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Номенклатура", 3);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименование","Номенклатура (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Номенклатура", 4);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименованиеПолное","Номенклатура (полное наименование)", ОписаниеТиповСтрока1000, ОписаниеТиповКолонка, "Номенклатура", 5);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ХарактеристикаНаименование", "Характеристика (наименование)", ОписаниеТиповСтрока150, ОписаниеТиповКолонка, "Характеристика", 1);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ХарактеристикаНаименованиеДляПечати", "Характеристика (наименование для печати)", ОписаниеТиповСтрока0000, ОписаниеТиповКолонка, "Характеристика", 2);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ХарактеристикаАртикул", "Характеристика (артикул)", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Характеристика", 3);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Остаток", "Остаток", ОписаниеТиповСтрока25, ОписаниеТиповЧисло10_0);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "СрокПополнения", "Срок пополнения", ОписаниеТиповСтрока25, ОписаниеТиповЧисло10_0);
	
	// ДополнительныеРеквизиты
	ЗагрузкаДанныхИзВнешнегоИсточника.ПодготовитьСоответствиеПоДополнительнымРеквизитам(НастройкиЗагрузкиДанных, Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_НоменклатураПоставщиков);
	Если НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов.Количество() > 0 Тогда
		
		ИмяПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяПоляДобавленияДополнительныхРеквизитов();
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, ИмяПоля, "Дополнительные реквизиты", ОписаниеТиповСтрока150, ОписаниеТиповСтрока11, , , , , , Истина, Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_НоменклатураПоставщиков);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	ОбновлятьДанные				= НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	ФиксированныйШаблон			= НастройкиЗагрузкиДанных.ФиксированныйШаблон;
	НастройкиПоиска				= НастройкиЗагрузкиДанных.НастройкиПоиска;
	
	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		// Номенклатура поставщика по Артикулу, Идентификатору, Наименованию
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуруПоставщиков(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных);		
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
		
			// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуру(СтрокаТаблицыФормы, НастройкиПоиска);
		
		КонецЕсли; 
		
		// Характеристика по Владельцу и Наименованию
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
			
			Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
				
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьХарактеристику(СтрокаТаблицыФормы);
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Остаток
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Остаток, СтрокаТаблицыФормы.Остаток_ВходящиеДанные);
		
		// Срок пополнения
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.СрокПополнения, СтрокаТаблицыФормы.СрокПополнения_ВходящиеДанные);
				
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	СтрокаТаблицыФормы._СтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураПоставщиков);
	
	ИмяСлужебногоПоля_ЗагрузкаВПриложениеВозможна = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	ИмяСлужебногоПоля_ЗаполненыНеПолностью = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗаполненыНеПолностью();
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля_ЗагрузкаВПриложениеВозможна] = СтрокаТаблицыФормы._СтрокаСопоставлена
											ИЛИ (ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура)
												И ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураПоставщиковНаименование));
												
	СтрокаТаблицыФормы[ИмяСлужебногоПоля_ЗаполненыНеПолностью] = НЕ СтрокаТаблицыФормы._СтрокаСопоставлена
		И НЕ ПустаяСтрока(СтрокаТаблицыФормы.НоменклатураПоставщиковНаименование)
		И НЕ ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура);
		
КонецПроцедуры

Процедура ОбработатьПодготовленныеДанные(СтруктураДанных, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	НастройкиЗагрузкиДанных			= СтруктураДанных.НастройкиЗагрузкиДанных;
	ОбновлятьСуществующие			= СтруктураДанных.НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	СоздаватьЕслиНеСопоставлено		= СтруктураДанных.НастройкиЗагрузкиДанных.СоздаватьЕслиНеСопоставлено;
	ТаблицаСопоставленияДанных		= СтруктураДанных.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных				= ТаблицаСопоставленияДанных.Количество();
	КоличествоЗаписейТранзакции		= 0;
	ТранзакцияОткрыта				= Ложь;
	
	Попытка
		
		Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
			
			Если НЕ ТранзакцияОткрыта 
				И КоличествоЗаписейТранзакции = 0 Тогда
				
				НачатьТранзакцию();
				ТранзакцияОткрыта = Истина;
				
			КонецЕсли;
			
			ЗагрузкаВПриложениеВозможна = СтрокаТаблицы[ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна()];
			
			СогласованноеСостояниеСтроки = (СтрокаТаблицы._СтрокаСопоставлена И ОбновлятьСуществующие) 
				ИЛИ (НЕ СтрокаТаблицы._СтрокаСопоставлена И СоздаватьЕслиНеСопоставлено);
				
			Если ЗагрузкаВПриложениеВозможна И СогласованноеСостояниеСтроки Тогда
				
				КоличествоЗаписейТранзакции = КоличествоЗаписейТранзакции + 1;
				
				Если СтрокаТаблицы._СтрокаСопоставлена Тогда
					
					ЭлементСправочника = СтрокаТаблицы.НоменклатураПоставщиков.ПолучитьОбъект();
					ЭлементСправочника.Заблокировать();
					
				Иначе
					
					ЭлементСправочника = Справочники.НоменклатураПоставщиков.СоздатьЭлемент();
					ЭлементСправочника.Владелец = НастройкиЗагрузкиДанных.КонтрагентПоставщик;
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.НоменклатураПоставщиковНаименование) Тогда
					ЭлементСправочника.Наименование = СтрокаТаблицы.НоменклатураПоставщиковНаименование;
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.АртикулПоставщика) Тогда
					ЭлементСправочника.Артикул = СтрокаТаблицы.АртикулПоставщика;
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.ИдентификаторПоставщика) Тогда
					ЭлементСправочника.Идентификатор = СтрокаТаблицы.ИдентификаторПоставщика;
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.Остаток) Тогда
					ЭлементСправочника.Остаток = СтрокаТаблицы.Остаток;
				КонецЕсли;
				Если НЕ ПустаяСтрока(СтрокаТаблицы.СрокПополнения) Тогда
					ЭлементСправочника.СрокПополнения = СтрокаТаблицы.СрокПополнения;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) Тогда
					ЭлементСправочника.Номенклатура = СтрокаТаблицы.Номенклатура;
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаТаблицы.Характеристика) Тогда
					ЭлементСправочника.Характеристика = СтрокаТаблицы.Характеристика;
				КонецЕсли;
				
				Если НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() > 0 Тогда
					
					ЗагрузкаДанныхИзВнешнегоИсточника.ОбработатьВыбранныеДополнительныеРеквизиты(ЭлементСправочника, СтрокаТаблицы._СтрокаСопоставлена, СтрокаТаблицы, НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты);
					
				КонецЕсли;
				
				ЭлементСправочника.Записать();
				
			КонецЕсли;
			
			ИндексТекущейСтроки	= ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицы);
			ТекстПрогресса		= СтрШаблон(НСтр("ru ='Обработано %1 из %2 строк...'"), ИндексТекущейСтроки, РазмерТаблицыДанных);
			
			ДлительныеОперации.СообщитьПрогресс(Цел(ИндексТекущейСтроки * 100 / РазмерТаблицыДанных), ТекстПрогресса);
			
			Если ТранзакцияОткрыта
				И КоличествоЗаписейТранзакции > ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.МаксимумЗаписейВОднойТранзакции() Тогда
				
				ЗафиксироватьТранзакцию();
				ТранзакцияОткрыта = Ложь;
				КоличествоЗаписейТранзакции = 0;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТранзакцияОткрыта 
			И КоличествоЗаписейТранзакции > 0 Тогда
			
			ЗафиксироватьТранзакцию();
			ТранзакцияОткрыта = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(Нстр("ru='Загрузка данных'", "ru"), УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.НоменклатураПоставщиков, , ОписаниеОшибки());
		ОтменитьТранзакцию();
		Возврат;
		
	КонецПопытки;
	
	Если ТранзакцияОткрыта Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

#КонецОбласти

#КонецЕсли

