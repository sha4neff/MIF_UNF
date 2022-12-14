#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	ОписаниеТиповСтрока25 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(25));
	ОписаниеТиповСтрока50 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100));
	ОписаниеТиповСтрока150 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	ОписаниеТиповСтрока200 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
	ОписаниеТиповСтрока1000 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(1000));
	ОписаниеТиповЧисло15_2 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповЧисло15_3 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный));
	
	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	Если ПустаяСтрока(ПолноеИмяОбъектаЗаполнения) 
		ИЛИ ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Запасы" Тогда
	
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Штрихкод", "Штрихкод", ОписаниеТиповСтрока200, ОписаниеТиповКолонка, "Номенклатура", 1, , Истина);
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Артикул", "Артикул", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Номенклатура", 2, , Истина);
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименование", "Номенклатура (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Номенклатура", 3, , Истина);
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименованиеПолное","Номенклатура (полное наименование)", ОписаниеТиповСтрока1000, ОписаниеТиповКолонка, "Номенклатура", 5, , Истина);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
			
			ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры");
			ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ХарактеристикаНаименование", "Характеристика (наименование)", ОписаниеТиповСтрока150, ОписаниеТиповКолонка, "Характеристика", 1);
			ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ХарактеристикаАртикул", "Характеристика (артикул)", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Характеристика", 2);
			
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы")
			ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуПроизводство") Тогда
			
			ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Спецификации");
			ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Спецификация", "Спецификация (наименование)", ОписаниеТиповСтрока150, ОписаниеТиповКолонка);
			
		КонецЕсли;
	
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Количество", "Количество", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_3, , , Истина);
		
		Если ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения") Тогда
			
			ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения, СправочникСсылка.ЕдиницыИзмерения");
			ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЕдиницаИзмерения", "Ед. изм.", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, , , , , ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения"));
		
		КонецЕсли;
		
	ИначеЕсли ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Расходы" Тогда
		
		ОписаниеТиповКолонка = Новый ОписаниеТипов("ПланСчетовСсылка.Управленческий");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Расход", "Статья расходов", ОписаниеТиповСтрока150, ОписаниеТиповКолонка, , , Истина);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Значение", "Сумма", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_2);
		
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Валюты");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Валюта", "Валюта", ОписаниеТиповСтрока150, ОписаниеТиповКолонка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	Если ПустаяСтрока(ПолноеИмяОбъектаЗаполнения) 
		ИЛИ ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Запасы" Тогда
	
		Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанныхЗапасы_xlsx");
		ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
		НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
		
		НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанныхЗапасы_mxl");
		
		Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанныхЗапасы_csv");
		ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
		НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
		
	ИначеЕсли ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Расходы" Тогда
		
		Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанныхРасходы_xlsx");
		ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
		НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
		
		НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанныхРасходы_mxl");
		
		Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанныхРасходы_csv");
		ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
		НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	НастройкиПоиска				= НастройкиЗагрузкиДанных.НастройкиПоиска;
	
	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		Если ПустаяСтрока(ПолноеИмяОбъектаЗаполнения) 
			ИЛИ ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Запасы" Тогда
		
			// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуру(СтрокаТаблицыФормы, НастройкиПоиска);
			
			// Характеристика по Владельцу и Наименованию
			Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
				
				Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
					
					ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьХарактеристику(СтрокаТаблицыФормы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			// Спецификация
			Если ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы")
				ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуПроизводство") Тогда
				
				Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
					
					ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСпецификацию(СтрокаТаблицыФормы.Спецификация, СтрокаТаблицыФормы.Спецификация_ВходящиеДанные, СтрокаТаблицыФормы.Номенклатура);
					
				КонецЕсли;
				
			КонецЕсли;
				
			// Количество
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Количество, СтрокаТаблицыФормы.Количество_ВходящиеДанные, 1);
			
			// ЕдиницыИзмерения по Наименованию (так же рассмотреть возможность прикрутить пользовательские ЕИ)
			Если ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения") Тогда
				
				ЗначениеПоУмолчанию = ?(ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура), СтрокаТаблицыФормы.Номенклатура.ЕдиницаИзмерения, Справочники.КлассификаторЕдиницИзмерения.шт);
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьЕдиницыИзмерения(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.ЕдиницаИзмерения, СтрокаТаблицыФормы.ЕдиницаИзмерения_ВходящиеДанные, ЗначениеПоУмолчанию);
				
			КонецЕсли;
				
			ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
			
		ИначеЕсли ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Расходы" Тогда
			
			// Расход по наименованию
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСчетУчетаЗатрат(СтрокаТаблицыФормы.Расход, СтрокаТаблицыФормы.Расход_ВходящиеДанные, ПланыСчетов.Управленческий.ПустаяСсылка());
			
			// Сумма
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Значение, СтрокаТаблицыФормы.Значение_ВходящиеДанные, 0);
			
			// Валюта
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьВалюту(СтрокаТаблицыФормы.Расход, СтрокаТаблицыФормы.Расход_ВходящиеДанные);
			
			ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения);
			
		КонецЕсли;
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	Если ПустаяСтрока(ПолноеИмяОбъектаЗаполнения) 
		ИЛИ ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Запасы" Тогда
		
		СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура)
			И СтрокаТаблицыФормы.Количество <> 0;
		
	ИначеЕсли ПолноеИмяОбъектаЗаполнения="Справочник.ШаблоныКалькуляций.ТабличнаяЧасть.Расходы" Тогда
		
		СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗначениеЗаполнено(СтрокаТаблицыФормы.Расход);
				
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти 	
	
#КонецЕсли
